# Exercises

Make sure you understand the feature you are analysing for vulnerabilities.
Before attempting any exploits, walk the "happy path" and investigate if the feature works as expected.


## Zero Stars

Give a devestating zero-start feedback to the store. You find the feedback form at `/#/contact`.

<details>
  <summary>❓ Hint 1</summary>
Can you enable the button with the developer tools?

</details>

<details>
  <summary>❓ Hint 2</summary>
There is another way: Use ZAP to find the request and replay it with a 0 value.
    
</details>

<details>
  <summary>📚 Solution</summary>
Here is the solution...
</details>


## Payback Time

Place an order that makes you rich.

<details>
  <summary>❓ Hint 1</summary>
When you order an item, you pay money. When you sell an item, you are being paid. Basic economics.
</details>

<details>
  <summary>❓ Hint 2</summary>
Have you tried ordering a negative amount of items?
</details>


## Confidential Document

Access a confidential document.
Reading the about us (`/#/about`) might nudge you in the right direction.


<details>
  <summary>❓ Hint 1</summary>
Robots are certainly disallowed to access confidential files.
How would you tell google to hide a directory?
</details>


## View Basket

You need some inspiration on what to buy. View another user's shopping basket.

<details>
  <summary>❓ Hint 1</summary>
Observe the HTTP traffic using ZAP when shopping. Is there a request with an interesting parameter that you could change in your favor?
</details>


## Forged Review

Privacy is important. Post a product review as another user or edit any user's existing review.

<details>
  <summary>❓ Hint 1</summary>
Observe the HTTP traffic using ZAP while submitting a review for the "Apple Juice". Can you alter any interesting parameters when sending a request to `/rest/products/1/reviews`?
</details>


## Login Admin

Sometimes it is boring to be a normal user. Login as the administrator (admin@juice-sh.op) instead.

<details>
  <summary>❓ Hint 1</summary>
User credentials are generally stored in a database, can you perform an injection that results in a positive query reply?
</details>

<details>
  <summary>❓ Hint 2</summary>
Don't forget to comment out the trash after the injected commands.
</details>


## User Credentials

Data is power. Steal all user credentials by abusing the search functionality.

<details>
  <summary>❓ Hint 0 (the endpoint)</summary>
The vulnerable (legacy) search endpoint is located under the following path `/rest/products/search?q=<SEARCH QUERY>`.
</details>

<details>
  <summary>❓ Hint 1</summary>
The endpoint is vulnerable to SQL injections.
When exploiting a SQL injection, make sure that you know how to properly close the query.
Start by crafting a simple query that doesn't result in an error (e.g. does `test';--` work, or are there for instance any open brackets left?)
</details>

<details>
  <summary>❓ Hint 2</summary>
Exploit the SQLi by crafting an `UNION SELECT` query to join the data from another table to the results.
</details>

<details>
  <summary>❓ Hint 3</summary>
Use the `sqlite_schema` table to extract the relevant table names.
</details>

<details>
  <summary>❓ Hint 4</summary>
Use the `PRAGMA_TABLE_INFO('TABLE NAME GOES HERE')` table to extract the relevant column names.
</details>


## NoSQL Manipulation

Look at the endpoint `PATCH /rest/products/reviews`.
Update multiple product reviews at the same time.

```javascript
module.exports = function productReviews () {
  return (req, res, next) => {
    const user = security.authenticatedUsers.from(req)
    db.reviews.update(
      { _id: req.body.id },
      { $set: { message: req.body.message } },
      { multi: true }
    ).then(
      result => {
        res.json(result)
      }, err => {
        res.status(500).json(err)
      })
  }
}
```

<details>
  <summary>❓ Hint 1</summary>
<a href="https://www.mongodb.com/docs/manual/reference/method/db.collection.update/">`db.collection.update` documentation</a>
and the <a href="https://www.mongodb.com/docs/manual/reference/operator/query/">query operators documentation</a>.

Which query allows you to change multiple reviews at the same time?
</details>


## Null-Byte Injection

Download `/ftp/package.json.bk`.
Note node.js handles null-bytes differently than the underlying library which is written in C.

<details>
  <summary>❓ Hint 1</summary>
In C strings are terminated by a NULL byte.
Thus the string "hello.txt■.md" (with ■ representing the NULL byte) will be seen as "hello.txt■.md" in node.js, but as "hello.txt" in the low level library that opens the file.
How can this be exploited, when the access verification happens in node.js?
</details>

<details>
  <summary>❓ Hint 2</summary>
A url encoded null byte is represented as "%00", however, make sure you properly encode it when submitting the request.
</details>

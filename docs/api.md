# Ahaskade Buyer API
For any request `app-api-key` is required. Wrong `app-api-key` would  
result in request fail with 401. When there is a new app version rollout,  
`app-api-key` will be refreshed so when the app get 401 then it should  
prompt users to update the app.

**Error Handling**

* HTTP 500 will be returned for any malformed requests such as missing request body attributes
* HTTP 401 will be returned if app-api-key doesn't match. when receiving this error app should ask user to update to latest app version
* HTTP 200 will be returned for any successful request
* HTTP 403 will be returned if user is inactive and sending requests (*
  not implemented yet)

**Request Format**
```
{
    "app-api-key": "test-key",
    "request": {
       "mobile-number": "+94773925720",
       "any-other-fields": "value-of-any-other-fields"
    }
}
```

# Login and Registration

## /user POST

**Description**

* Use to register user for the first time and re-login to the app. It is
  expected that app should keep track of the last login date and force
  users to re-login to the app (general recommendation is every 7 days)

**Request**
```
{
	"app-api-key": "test-key",
        "request":  {
	     "mobile-number": "+9477777777"
       }
}
```

**Response - Type 1 (For new registrations)**
```
{
    "code": 7865
}
```
**Response - Type 2 (For existing users)**
```
{
    "code": 7575,
    "mobile-number": "+9477777777",
    "profile": {
          "name": "User X",
          "cities": ["list of cities"]
      },
     "status": "active"
}
```
**Special notes on response**

* If user is a new user, then SMS code will be returned - response #1.
* If user (mobile number) is already found in the system as a registered
  user, then the profile section will be returned - response #2.
* App should skip the registration, update the profile section of the
  app using the response payload and navigate to main screen if profile
  section is available in the response.
* App should only proceed if status is active. If the user is not active
  rest of the calls will be rejected by the API and send HTTP 403

## /user PUT

**Description**

* create a new user or update existing user
* to update the existing profile entire payload has to be sent

**Request**
```
{
    "app-api-key": "test-key",
    "request": {
    "mobile-number": "+9477777777",
	    "profile": {
	          "name": "User X",
	          "title": "Name of the shop",
	          "cities": ["list of cities"],
	          "location":{
	              "lat": 60.908525949046339,
	              "lon": 79.92170921759156
	           }
	     }
    }
}
```
**Special notes on request**
* cities is the list of cities one seller can make deliveries. Currently
  should be limited to 10. If more than 10 are sent, only accepts first
  10 elements by the API
* location attribute is reserved for future use for Seller app. This can
  be set to `0.0` for both `lat` and `lon` when making the request

**Response**
```
{
    "mobile-number": "+9477777777",
    "profile": {
          "name": "User X",
          "title": "Name of the shop",
          "cities": ["list of cities"]
      }
}
```

# Location Based Queries
## /geo/current POST
**Description**

* this is used to get the closest city for a given GPS coordinates
* this should be used to display the corresponding city when a seller
  change the location in the map. For sellers they can add multiple
  cities using this method - like when they drag a pin to a location and
  then app should call this api to get the location

**Request**
```
{
    "app-api-key": "test-key",
    "request": {
        "mobile-number": "+9477777777",
    	"lat": 6.908525949046339,
    	"lon": 79.92170921759156
    }
}
```

**Response**
```
{
    "city": "Battaramulla"
}
```

php-fpm:hardened
================

An opinionated and hardened PHP 5.6 with a few extras:

Inherited from php-fpm
----------------------
* Composer
* PEAR
* libsodium
* zmq

Included Extras
---------------
* suhosin

Description
-----------

This image makes several changes to PHP in the interest of mitigating common attack vectors, and providing a more secure foundation to build on. This does not magically secure your application. It is not a substitute for vigilance and code auditing. It does however, require you to explicitly state when you are doing *some things* that often have security implications by creating an image that includes those overrides.

This image is opinionated. It may break your application. A few of the changes are (this is not an exhaustive list):

* Many system-related functions are disabled.
* Writable files will not be executed.
* Dynamic loading is disabled.
* fopen and include may not load from a URL.
* the /e flag is disabled on preg_match.
* Cookies are only sent over HTTPS.
* Cookies have an HttpOnly flag set, and should not be readable on the client side (assuming the browser respects this flag, which most do).
* Session IDs must be set in Cookies. They will be ignored in request parameters.

Preconfigured to listen on ```tcp/9000```.

# envoke

I have a back end projects in Lisp which uses layers of data intensive
operations. But quite often i forgot to load the the right environment with all
the enviroment variables and configuration. The cause the program fails and i
have to start again. The intention of the project is to allow to break the flow
and allow for setting up enviroment variable interactivly and continue the
operation flow. Which at least not let me start the operation again. Why create
this package? because i use this feature in my other projects also Why create
this package? because i use this feature in my other projects also and i don't like code repetitions.

### _Aniket Narvekar_

It allows you to break the project project when environment variable does not
exists. allows user an option to create an respetive enviroment variable
interactivly and continue the operations.

### API's

#### getenv

Return an value of environment variable if present else raise `undefined-env`
condition with `SET-ENV` restart. On selection of `SET-ENV` restart. allows
interactively set new value for respective environment variable.

### (setf getenv)

Set value for enviroment variable. See `uiop:getenv`.

### undefined-env

A condition object which will raised by `GETENV` function if env does not
exists.

### undfined-env-name

A method that return enviroment variable name from `undefined-env` condition.

### invoke-set-env-restart

Invoke `SET-ENV` restart with NEW-VALUE for CONDITION if present in the scope.

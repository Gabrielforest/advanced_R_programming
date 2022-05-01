
# Debugging ---------------------------------------------------------------

# The debug() and debugonce() functions can be called on other functions 
# to turn on the “debugging state” of a function. Calling debug() on a 
# function makes it such that when that function is called, you immediately 
# enter a browser and can step through the code one expression at a time.

debug(lm)

# A call to debug(f) where f is a function is basically equivalent 
# to trace(f, browser) which will call the browser() function upon entering the function.

# The debugging state is persistent, so once a function is flagged for debugging, 
# it will remain flagged. Because it is easy to forget about the debugging state 
# of a function, the debugonce() function turns on the debugging state the next 
# time the function is called, but then turns it off after the browser is exited.


# recover -----------------------------------------------------------------

# The recover() function is not often used but can be an essential tool when 
# debugging complex code. Typically, you do not call recover() directly, but 
# rather set it as the function to invoke anytime an error occurs in code. 
# This can be done via the options() function.

options(error = recover)

# Usually, when an error occurs in code, the code stops execution and you are
# brought back to the usual R console prompt. However, when recover() is in
# use and an error occurs, you are given the function call stack and a menu.

as.numeric(today)

# Selecting a number from this menu will bring you into that function on the call
# stack and you will be placed in a browser environment. You can exit the browser
# and then return to this menu to jump to another function in the call stack.

# The recover() function is very useful if an error is deep inside a nested 
# series of function calls and it is difficult to pinpoint exactly where an error
# is occurring (so that you might use browser() ortrace()). In such cases, 
# the debug() function is often of little practical use because you may need
# to step through many many expressions before the error actually occurs. 
# Another scenario is when there is a stochastic element to your code so that 
# errors occur in an unpredictable way. Using recover() will allow you to
# browse the function environment only when the error eventually does occur.
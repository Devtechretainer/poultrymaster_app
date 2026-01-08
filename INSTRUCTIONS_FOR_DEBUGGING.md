I have added detailed logging to the application to help diagnose the persistent "401 Unauthorized" error. My previous fixes are still in place, but since the error continues, we need more information to find the root cause.

Here’s what I’ve done:
1.  I added logging to the login process to see the exact response from the server.
2.  I added logging to see the exact user data, including the authentication token, that is saved to your device after you log in.
3.  I added logging to the employee fetching process to see the token that is being read from your device and used for the API call.

**What I need from you:**

1.  Please run the application in **debug mode**.
2.  **Log out** of the application if you are already logged in.
3.  **Log in** again with your credentials.
4.  Navigate to the **Employees page**, which should trigger the "failed to load employees" error.
5.  **Copy the entire output** from the **Debug Console** and paste it here in the chat.

This debug output will contain the logs I've added, which will show me the lifecycle of the authentication token and help me pinpoint exactly where the process is failing.
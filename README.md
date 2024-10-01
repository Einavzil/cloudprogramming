# cloudprogramming

## Einav Zilka

To run, aws secrets are needed. They can be set with the following commands:

Windows

```
setx AWS_ACCESS_KEY_ID {your_access_key_id}
setx AWS_SECRET_ACCESS_KEY {your_secret_key}
```

Mac/Unix

```
export AWS_ACCESS_KEY_ID {your_access_key_id}
export AWS_SECRET_ACCESS_KEY {your_secret_key}
```

When "terraform apply" is complete, the cloudfront domain address will be printed in the terminal.
Keep in mind that it might take a few minutes for the resources to initialize before accessing the web page.

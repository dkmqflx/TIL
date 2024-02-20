## .gitmessage

- A gitmessage file is a template file that Git uses to pre-populate the text in the commit message editor when you create a commit.

- The purpose of this file is to provide a standardized commit message format for a project, helping to ensure that all commit messages adhere to a specific structure or include certain types of information

- By specifying a commit message template, you can maintain a consistent style when writing commit messages.

```bash
$ touch .gitmessage.txt

```

- Below are examples of commit message templates.

```bash

# <type>[optional scope]: <description>
# No more than 50 chars. #### 50 chars is here:  #

# Remember blank line between title and body.

# [optional body]
# Wrap at 72 chars. ################################## which is here:  #

# [optional footer(s)]
# Include at least one empty line before it. Format:


# build: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
# ci: Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
# docs: Documentation only changes
# feat: A new feature
# fix: A bug fix
# perf: A code change that improves performance
# refactor: A code change that neither fixes a bug nor adds a feature
# style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
# test: Adding missing tests or correcting existing tests
```

- Register it in commit.template through the following command.

```bash
$ git config commit.template .gitmessage.txt

```

- When you run git commit without the -m flag, Git will open your configured commit message editor with the contents of your gitmessage file pre-loaded. You can then edit the message according to the guidelines you've set.

- If you want to apply different commit message templates for each repository, you can use the prepare command to execute the template accordingly.

```json
{
  "scripts": {
    "prepare": "git config commit.template ./.gitmessage.txt"
  }
}
```

![](https://storageapi.fleek.co/fleek-team-bucket/logos/capp.png)

# The CAP (Certified Asset Provenance) Motoko Library

Transaction history & asset provenance for NFT’s & Tokens on the Internet Computer

> CAP is an open internet service providing transaction history & asset provenance for NFT’s & Tokens on the Internet Computer. It solves the huge IC problem that assets don’t have native transaction history, and does so in a scalable, trustless and seamless way so any NFT/Token can integrate with one line of code.

## 📒 Table of Contents 
- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Add the library to a project](#add-the-library-to-a-project)
- [Cap Motoko library specs](#cap-motoko-library-specs)
  - [Cap](docs/Cap.md)
  - [Root](docs/Root.md)
  - [Router](docs/Router.md)
  - [Types](docs/Types.md)
- [Release](#release)
- [Contribution guideline](#contribution-guideline)
- [Links](#links)

## 👋 Getting started

You're required to have [Vessel Motoko package manager](https://github.com/dfinity/vessel) binary installed and configured in your operating system.

Here's a quick breakdown, but use the original documentation for latest details:

- Download a copy of the [vessel binary](https://github.com/dfinity/vessel/releases) from the [release page](https://github.com/dfinity/vessel/releases) or build one yourself
- Run vessel init in your project root.

  ```sh
  vessel init
  ```

- Edit `package-set.dhall` to include the [Cap Motoko Library](https://github.com/Psychedelic/cap-motoko-library) as described in [add the library to a project](#add-the-library-to-a-project).

- Include the `vessel sources` command in the `build > packtool` of your `dfx.json`

  ```sh
  ...
  "defaults": {
    "build": {
      "packtool": "vessel sources"
    }
  }
  ...
  ```

- From then on, you can simply run the [dfx build command](https://smartcontracts.org/docs/developers-guide/cli-reference/dfx-build.html)

  ```sh
  dfx build
  ```

## 🤖 Add the library to a project

After you have initialised [Vessel](https://github.com/dfinity/vessel), edit the `package-set.dhall` and include the [Cap Motoko library](https://github.com/Psychedelic/cap-motoko-library) and the version, as available in the releases of [Cap Motoko Library](https://github.com/Psychedelic/cap-motoko-library).

In the example below of our `package-set.dhall`, we are using `v1.0.0`:

```sh
let upstream = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.6.7-20210818/package-set.dhall sha256:c4bd3b9ffaf6b48d21841545306d9f69b57e79ce3b1ac5e1f63b068ca4f89957
let Package =
    { name : Text, version : Text, repo : Text, dependencies : List Text }

let
  additions =
      [{ name = "base"
      , repo = "https://github.com/Psychedelic/cap-motoko-library"
      , version = "v1.0.0"
      , dependencies = [] : List Text
      }] : List Package

in  upstream # additions
```

## 🚀 Release

**TLDR; Common tag release process, which should be automated shortly by a semanatic release process in the CI**

Create a new tag for the branch commit, you'd like to tag (e.g. for v1.0.0):

```sh
git tag v1.0.0
```

Complete by pushing the tags to remote:

```sh
git push origin --tags
```

## 🙏 Contribution guideline

Create branches from the `main` branch and name it in accordance to **conventional commits** [here](https://www.conventionalcommits.org/en/v1.0.0/), or follow the examples bellow:

```txt
test: 💍 Adding missing tests
feat: 🎸 A new feature
fix: 🐛 A bug fix
chore: 🤖 Build process or auxiliary tool changes
docs: ✏️ Documentation only changes
refactor: 💡 A code change that neither fixes a bug or adds a feature
style: 💄 Markup, white-space, formatting, missing semi-colons...
```

The following example, demonstrates how to branch-out from `main`, creating a `test/a-test-scenario` branch and commit two changes!

```sh
git checkout main

git checkout -b test/a-test-scenario

git commit -m 'test: verified X equals Z when Foobar'

git commit -m 'refactor: input value changes'
```

Here's an example of a refactor of an hypotetical `address-panel`:

```sh
git checkout main

git checkout -b refactor/address-panel

git commit -m 'fix: font-size used in the address description'

git commit -m 'refactor: simplified markup for the address panel'
```

Once you're done with your feat, chore, test, docs, task:

- Push to [remote origin](https://github.com/Psychedelic/cap-explorer.git)
- Create a new PR targeting the base **main branch**, there might be cases where you need to target to a different branch in accordance to your use-case
- Use the naming convention described above, for example PR named `test: some scenario` or `fix: scenario amend x`
- On approval, make sure you have `rebased` to the latest in **main**, fixing any conflicts and preventing any regressions
- Complete by selecting **Squash and Merge**

If you have any questions get in touch!

## 🔗 Links

- Visit [our website](https://cap.ooo)
- Read [our announcement](https://medium.com/@cap_ois/db9bdfe9129f?source=friends_link&sk=924b190ea080ed4e4593fc81396b0a7a)
- Visit [CAP Service repository](https://github.com/Psychedelic/cap)
- Visit [CAP-js repository](https://github.com/Psychedelic/cap-js/) 
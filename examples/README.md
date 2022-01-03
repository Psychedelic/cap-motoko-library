# 🦖 Cap Motoko Library examples

The examples serve to provide information on how to use the Motoko Library, mainly in your local replica environment.

Use the documentation here to understand how to run the separate services which are required in your local development environment.

# 🤔 How to run the examples?

**TLDR;** Deploy the example to mainnet and use an actor to interact with it, either via [DFX CLI](https://sdk.dfinity.org/docs/developers-guide/cli-reference.html) or your [Agentjs](https://github.com/dfinity/agent-js).

If planning to run the examples in your local environment and not the mainnet network, then the main [Cap repo](https://github.com/Psychedelic/cap) should be cloned and deployed to your local replica.

Alternatively, the Cap Service handling can be borrowed from the [Cap Explorer](https://github.com/Psychedelic/cap-explorer), which is documented and is easy to grasp.

Once the `Cap router` is running in your local, copy the Router id; for our reading we'll name it `<Router ID>` to keep it easy to follow!

When ready, open the directory for one of our examples e.g. the `/cap-motoko-library/examples/insert` and deploy the example to your local replica network, as follows:

```sh
dfx deploy cap-motoko-example
```

Make sure you execute the command in the correct directory, where a `dfx.json` exists describing the canister `cap-motoko-example`, otherwise it'll fail.

💡 When deploying, the `cap-motoko-example` is pulling a particular version of the [Cap Motoko Library](https://github.com/Psychedelic/cap-motoko-library) via the [Vessel Package Manager](https://github.com/dfinity/vessel/releases) which is described in the main README of the [Cap Motoko Library](https://github.com/Psychedelic/cap-motoko-library) repository. For example, you'll find the field `version` in the additions setup in the `package-set.dhall`, you can have another tag or a commit hash.

We'll use `<Application Token Contract ID>` to keep it easy to follow!

Here's an example of how the output should look like:

```sh
Deploying: cap-motoko-example
All canisters have already been created.
Building canisters...
Installing canisters...
Creating UI canister on the local network.
The UI canister on the "local" network is "<xxxxx>"
Installing code for canister cap-motoko-example, with canister_id "<Application Token Contract ID>"
Deployed canisters.
```

In the output, copy the `<Application Token Contract ID>` because you are going to use it to send requests via the DFX CLI!

Open the file  `/cap-motoko-library/examples/insert/src/main.mo` and replace the following variable to the one you found in your environment:

```sh
let local_replica_router_id = "<Router ID>";
```

💡 Of course, do NOT include the angle brackets and notice that the `...` is just to say that there are other lines of code inbetween, so feel free to ignore!

Now, we need to push our example source code to Cap! For that we have a `handshake` process that creates a new Root canister for us, with the right controller.

For our example, we're going to use the [DFX CLI]() to call a method in our example application actor, called `init`

```sh
dfx canister call <Application Token Contract ID> init "()"
```

It should take a bit, and once completed you'll find the output it similar to:

```sh
()
```

Where `()` is the returned value, if we did NOT get any errors during the process handling!

From then on we can simple use the remaining methods available, such as `insert`, this means that we do the initialisation only once and not everytime we need to make a Cap call.

To complete, we execute the `insert` to push some data to our Root bucket for our `<Application Token Contract ID>` example app.

```sh
dfx canister call <Application Token Contract ID> insert "()"
```

Here's how it looks:

```sh
(variant { ok = 0 : nat64 })
```

The `(variant { ok = 0 : nat64 })` is a wrapped response of the expected returned value as we can verify by looking at the [Candid](https://github.com/Psychedelic/cap/blob/main/candid/root.did#L57) for Cap Root. It's wrapped by our example `insert` method.

👋 That's it! You can now use the Cap Motoko Library in your local replica and the same knowledge can be applied to deploy to the mainnet!
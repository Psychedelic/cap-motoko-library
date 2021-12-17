import Principal "mo:base/Principal";
import CapMotokoLibrary "mo:cap-motoko-library/Cap";
import Root "mo:cap-motoko-library/Root";
import Result "mo:base/Result";
import Types "mo:cap-motoko-library/Types";

actor {
    type DetailValue = Root.DetailValue;
    type Event = Root.Event;
    type IndefiniteEvent = Root.IndefiniteEvent;

    // Start a local replica network
    // deploy the Cap Service in your local replica network
    // and copy the local replica router id
    // the Cap repo is located at https://github.com/Psychedelic/cap
    // see the releases https://github.com/Psychedelic/cap/tags
    // to ensure you get a working version
    let local_replica_router_id = "rrkah-fqaaa-aaaaa-aaaaq-cai";

    // If the local replica router is not set
    // then the mainnet id is used "lj532-6iaaa-aaaah-qcc7a-cai" 
    // and because the expected argument is an optional we pass as ?xxx
    let cap = CapMotokoLibrary.Cap(?local_replica_router_id);

    // Your application canister token contract id
    // e.g. execute the command dfx canister id cap-motoko-example
    // in the cap-motoko-library/examples directory
    // after you have deployed the cap-motoko-example
    let token_contract_id = "qsgjb-riaaa-aaaaa-aaaga-cai";

    // The number of cycles to use when initialising
    // the handshake process which creates a new canister
    // and install the bucket code into cap service
    let creation_cycles : Nat = 100000000000;

    public func init() : async () {
        // As a demo, the parameters are hard-typed here
        // but could be declared in the function signature
        // and pass when executing the request
        let handshake = await cap.handshake(
          local_replica_router_id,
          token_contract_id,
          creation_cycles
        );
    };

    public shared (msg) func insert() : async Result.Result<Nat64, Types.InsertTransactionError> {
        let event : IndefiniteEvent = {
            operation = "transfer";
            details = [("key", #Text "value")];
            caller = msg.caller;
        };

        let transactionId = await cap.insert(event);

        return transactionId;
    };
};

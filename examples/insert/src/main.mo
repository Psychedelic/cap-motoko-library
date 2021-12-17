import Principal "mo:base/Principal";
import CapMotokoLibrary "mo:cap-motoko-library/Cap";
import Root "mo:cap-motoko-library/Root";

actor {
    type DetailValue = Root.DetailValue;
    type Event = Root.Event;
    type IndefiniteEvent = Root.IndefiniteEvent;

    let local_replica_router_id = "rrkah-fqaaa-aaaaa-aaaaq-cai";
    let cap_service_router : Principal = Principal.fromText(local_replica_router_id);

    // If the local replica router is not set
    // then the mainnet id is used "lj532-6iaaa-aaaah-qcc7a-cai" 
    let cap = CapMotokoLibrary.Cap(cap_service_router);

    // Your application canister token contract id
    let token_contract_id = "rkp4c-7iaaa-aaaaa-aaaca-cai";

    // The number of cycles to use when initialising
    // the handshake process which creates a new canister
    // and install the bucket code into cap service
    let creation_cycles : Nat = 100000000000;

    public func init() : async () {
        // As a demo, the parameters are hard-typed here
        // but could be declared in the function signature
        // and pass when executing the request
        let handshake = await cap.awaitForHandshake(
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

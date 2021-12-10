import Principal "mo:base/Principal";
import CapMotokoLibrary "mo:cap-motoko-library/Cap";
import Root "mo:cap-motoko-library/Root";

actor {
    type DetailValue = Root.DetailValue;
    type Event = Root.Event;
    type IndefiniteEvent = Root.IndefiniteEvent;

    // Required by the constructor related handshake
    let canister_id : Principal = Principal.fromText("ai7t5-aibaq-aaaaa-aaaaa-c");
    let creation_cycles : Nat = 15000000000;

    let cap = CapMotokoLibrary.Cap(canister_id, creation_cycles);

    public shared (msg) func start() : async Result.Result<Nat64, ()> {
        let event : IndefiniteEvent = {
            operation = "transfer";
            details = [("key", #Text "value")];
            caller = msg.caller;
        };

        let transactionId = await cap.insert(event);

        return transactionId;
    };
};

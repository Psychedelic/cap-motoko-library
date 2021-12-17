/// Cap library
///
/// Minimal working example:
///
/// ```motoko
/// import Cap "mo:cap-motoko-library/Cap";
/// ```

import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";
import Cycles "mo:base/ExperimentalCycles";
import Root "Root";
import Types "Types";
import Router "Router";
import IC "IC";

let router_mainnet_id = "lj532-6iaaa-aaaah-qcc7a-cai";

module {
    public class Cap(router_id: ?Text) {
        let router_id = Option.get(router_id, router_mainnet_id);
        
        var rootBucket: ?Text = null;
        let ic: IC.ICActor = actor("aaaaa-aa");

        public func getTransaction(id: Nat64) : async Result.Result<Root.Event, Types.GetTransactionError> {
            let root = switch(rootBucket) {
                case(?r) { r };
                case(_) { "" }; // unreachable
            };
            let rb: Root.Self = actor(root);

            let transaction_response = await rb.get_transaction({ id=id; witness=false; }); 

            switch(transaction_response) {
                case (#Found(event, witness)) {
                    switch(event) {
                        case (null) {
                            #err(#invalidTransaction)
                        };
                        case (?event) {
                            #ok(event)
                        }
                    }
                };
                case (#Delegate(_, _)) {
                    #err(#unsupportedResponse)
                }
            }
        };

        public func insert(event: Root.IndefiniteEvent) : async Result.Result<Nat64, Types.InsertTransactionError> {
            let root = switch(rootBucket) {
                case(?r) { r };
                case(_) { "" }; // unreachable
            };
            let rb: Root.Self = actor(root);

            let insert_response = await rb.insert(event);

            // TODO: throw on error

            #ok(insert_response)
        };

        public func handshake(router_id : Text, token_contract_id : Text, creation_cycles: Nat): async () {
            let router: Router.Self = actor(router_id);

            let result = await router.get_token_contract_root_bucket({
                witness=false;
                canister=canister_id;
            });

            switch(result.canister) {
                case(null) {
                    let settings: IC.CanisterSettings = {
                        controllers = ?[Principal.fromText(router_id)];
                        compute_allocation = null;
                        memory_allocation = null;
                        freezing_threshold = null;
                    };

                    // Add cycles and perform the create call
                    Cycles.add(creation_cycles);

                    let create_response = await ic.create_canister(?settings);

                    // Install the cap code
                    let canister = create_response.canister_id;

                    // Extendc controllers by including the token contract id
                    // as otherwise, the Cap Service install_bucket_code
                    // fails because it lacks the token contract id as controller
                    await ic.update_settings({
                        canister_id = canister;
                        settings = {
                            controllers = ?[Principal.fromText(router_id), Principal.fromText(token_contract_id)];
                            compute_allocation = null;
                            memory_allocation = null;
                            freezing_threshold = null;
                        };
                    });

                    await router.install_bucket_code(canister);

                    // Find root by the token contract id
                    let result = await router.get_token_contract_root_bucket({
                        witness=false;
                        canister=Principal.fromText(token_contract_id);
                    });

                    switch(result.canister) {
                        case(null) {
                            assert(false);
                        };
                        case(?canister) {
                            rootBucket := ?Principal.toText(canister);
                        };
                    };
                };
                case (?canister) {
                    rootBucket := ?Principal.toText(canister);
                };
            };
        };
    };
}

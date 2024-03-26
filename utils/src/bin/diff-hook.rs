use libnixstore::{hash_path, Radix::Base32};
use nix_hash_collection_utils::*;
use reqwest::Result;

#[tokio::main]
async fn main() -> Result<()> {
    let token = read_env_var_or_panic("HASH_COLLECTION_TOKEN");
    let collection_server = read_env_var_or_panic("HASH_COLLECTION_SERVER");
    let out_path = read_env_var_or_panic("OUT_PATH");
    let rebuild_path = read_env_var_or_panic("REBUILD_PATH");
    let drv_path = read_env_var_or_panic("DRV_PATH");
    let drv_ident = parse_drv_hash(&drv_path);

    println!(
        "Uploading hash of build output for derivation {0} to {1}",
        drv_ident, collection_server
    );

    let output_attestations: Vec<_> = vec![
        OutputAttestation {
            output_path: &out_path,
            output_hash: format!("sha256:{0}", hash_path("sha256", Base32, &rebuild_path).unwrap()),
        }
    ];

    post(&collection_server, &token, &drv_ident, &output_attestations).await?;
    Ok(())
}

use std::sync::Arc;
use grpcio::*;
use firestore_grpc::google::firestore::v1::firestore_client::{FirestoreClient};

fn main() {
    let env = Arc::from(EnvBuilder::new().build());
    let creds = ChannelCredentials::google_default_credentials().unwrap();
    let ch = ChannelBuilder::new(env).secure_connect("firestore.googleapis.com", creds);
    let client = FirestoreClient::new(ch);
}

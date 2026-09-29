//! {{project_name}} - AI-assisted development project
//!
//! {{project_description}}
//!
//! This is a template for AI-assisted development projects using OpenRouter.
//! It follows clean code principles with minimal comments (only WHY/ALGORITHM/TODO).

use anyhow::Result;
use clap::Parser;
use tracing::{info, Level};
use tracing_subscriber::FmtSubscriber;

mod config;
mod ai;

use config::Config;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Configuration file path
    #[arg(short, long, default_value = "config.toml")]
    config: String,

    /// Enable debug logging
    #[arg(short, long)]
    debug: bool,
}

#[tokio::main]
async fn main() -> Result<()> {
    let args = Args::parse();

    // Initialize logging
    let level = if args.debug { Level::DEBUG } else { Level::INFO };
    let subscriber = FmtSubscriber::builder()
        .with_max_level(level)
        .finish();
    tracing::subscriber::set_global_default(subscriber)?;

    info!("Starting {{project_name}} v{}", env!("CARGO_PKG_VERSION"));

    // Load configuration
    let config = Config::load(&args.config).await?;
    info!("Configuration loaded");

    // Initialize AI client
    let ai_client = ai::Client::new(config.openrouter)?;
    info!("AI client initialized");

    // Run main logic
    run(ai_client).await?;

    info!("Done");
    Ok(())
}

async fn run(ai_client: ai::Client) -> Result<()> {
    // TODO: Implement main application logic
    // WHY: This is a template - replace with actual implementation
    info!("Application running - replace with actual logic");
    
    // Example: Use AI client
    // let response = ai_client.chat("Hello, world!").await?;
    // info!("AI response: {}", response);
    
    Ok(())
}
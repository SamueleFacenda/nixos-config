//! {{project_name}} - AI-assisted development project
//!
//! {{project_description}}
//!
//! This is a template for AI-assisted development projects using OpenRouter.
//! It follows clean code principles with minimal comments (only WHY/ALGORITHM/TODO).

pub mod config;
pub mod ai;

pub use config::Config;
pub use ai::AIClient;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_reexports() {
        // Verify re-exports work
        let _config = Config::default();
        let _client_type = std::any::type_name::<AIClient>();
    }
}
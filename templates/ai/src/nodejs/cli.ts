import { Config } from './config.js';
import { AIClient } from './ai.js';
import { program } from 'commander';
import chalk from 'chalk';
import ora from 'ora';

program
  .name('{{project_name}}')
  .description('{{project_description}}')
  .version('0.1.0')
  .option('-c, --config <path>', 'Configuration file path', 'config.toml')
  .option('-d, --debug', 'Enable debug logging', false)
  .parse(process.argv);

const options = program.opts();

async function main() {
  console.log(chalk.green.bold('🚀 {{project_name}} v0.1.0'));
  console.log(chalk.gray('   {{project_description}}'));
  console.log();

  // Load configuration
  const spinner = ora('Loading configuration...').start();
  const config = await Config.load(options.config);
  spinner.succeed('Configuration loaded');

  if (options.debug) {
    config.debug = true;
    process.env.DEBUG = '*';
  }

  // Initialize AI client
  const aiSpinner = ora('Initializing AI client...').start();
  const aiClient = new AIClient(config.openrouter);
  aiSpinner.succeed('AI client initialized');

  // Run main logic
  await run(aiClient);
  
  console.log(chalk.green('✅ Done'));
}

async function run(aiClient: AIClient) {
  // TODO: Implement main application logic
  // WHY: This is a template - replace with actual implementation
  console.log(chalk.yellow('⚠️  Application running - replace with actual logic'));
  
  // Example usage:
  // const response = await aiClient.chat('Hello, world!');
  // console.log(chalk.cyan('AI response:'), response);
}

main().catch((error) => {
  console.error(chalk.red('❌ Error:'), error);
  process.exit(1);
});
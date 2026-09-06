# filorgk

`filorgk` is a Bash command-line tool that automatically organizes files into structured folders based on file type and category. It is designed for directories such as `Downloads` and `Desktop`, where files can quickly become difficult to manage.
## DEMO


https://github.com/user-attachments/assets/b26f769a-0044-4371-a9d7-5860c021c4a4


## Features

- Organizes files through an interactive command-line workflow.
- Supports delete, move, and auto-arrange operations.
- Sorts files by criteria such as extension, date, size, and modification time.
- Supports both short and long-form flags:
	- `-h`, `--help`: Display usage information.
	- `-v`, `--version`: Display the installed version.
	- `-r`, `--reset`: Delete filorgk logs and reset the stored run state.
- Creates logs and backups under the user's local data and state directories.

## Installation

Clone the repository and make the launcher executable:

```bash
git clone https://github.com/4kit1-glitch/filorgk.git
cd filorgk
chmod +x filorgk
```

For a user-local installation, symlink the launcher into `~/.local/bin`:

```bash
mkdir -p ~/.local/bin
ln -sfn "$(pwd)/filorgk" ~/.local/bin/filorgk
```

Ensure `~/.local/bin` is included in your `PATH`. You can then run `filorgk` from any directory. As an alternative, copy the executable directly:

```bash
cp filorgk ~/.local/bin/filorgk
```

## Usage

Run the command without options to start the interactive organizer:

```bash
filorgk
```

Display help, version information, or reset the logs and run state:

```bash
filorgk -h
filorgk --help

filorgk -v
filorgk --version

filorgk -r
filorgk --reset
```

Core organizing command syntax:

```text
filorgk [ORGANIZING COMMAND] [OPTIONS]
```

The interactive workflow currently prompts for the target directory, the primary operation, and the organizing criteria.

## How It Works

filorgk scans a target directory, identifies the files it contains, and applies the selected operation to sort them into category-based subfolders. The tool maintains logs and creates backups as part of its workflow, keeping file operations safe and non-destructive by default.

## Project Structure

```text
filorgk/
├── filorgk                         # Executable Bash entry point
├── README.md                       # Project documentation
└── lib/
		├── core/
		│   ├── 00_logging.sh           # Logging and error-reporting helpers
		│   ├── 01_dir_finder.sh         # Target-directory and file discovery
		│   ├── 02_backup.sh             # Backup handling for file operations
		│   ├── 03_get_files.sh          # Collects and presents discovered files
		│   └── 04_get_options.sh        # Interactive operation and criteria prompts
		└── functions/
				├── 0_move.sh                # File move operations
				├── 1_auto_adjust.sh         # Automatic file organization operations
				├── 2_delete.sh               # File deletion operations
				├── 3_execute.sh              # Dispatches the selected operation
				└── 4_parse_flags.sh          # Parses command-line flags and usage
```

## Author

Kengah Ireneaus
GitHub: [4kit1-glitch](https://github.com/4kit1-glitch)

## License
None

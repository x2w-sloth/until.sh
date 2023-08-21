# until.sh

Shell script to calculate date differences.


## Usage

Counts number of days until a specific date, using the `ISO-8601` date format of `YYYY-MM-DD`.

```bash
until.sh  2023-12-31
```

Use the `-f` flag to set the date to begin counting from, otherwise the local system date is used.

```bash
until.sh  2023-12-31 -f 2023-12-10
# 21 days from 2023-12-10 until 2023-12-31
```

Use the `-d` flag to only print out the number of days, useful if you wish to pipe the output to other programs.

```bash
until.sh  2023-12-31 -f 2023-12-10 -d
# 21
```

## License

This script is distributed under the permissive MIT license.

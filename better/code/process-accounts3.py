import re
import monkey_plus
import argparse

def get_5k_balances(rows):
    for row in rows:
        if re.match(r"5\d{3}\.\d{2}", row):
            balance, account_num, owner = row.split(",")
            yield (f"Account: {account_num}\n"
                   f"  Owner: {owner.strip()}\n"
                   f"Balance: ${float(balance):,.2f}\n")

# ... many more functions ...

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("datafile", type=str, help="CSV data file")
    parser.add_argument(
        "-f", "--function", action="store",
        default="get_5k_balances")
    args = parser.parse_args()

    func = eval(args.function)
    for account in func(open(args.datafile)):
        print(account)

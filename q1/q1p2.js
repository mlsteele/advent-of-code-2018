fs = require("fs")
let exprs = fs.readFileSync("./input.txt", {encoding: 'utf-8'}).trim().split("\n")
let val = 0
let reached = {0: true}
while (true) {
  for (let expr of exprs) {
    val = eval("" + val + expr)
    if (reached[val]) {
      console.log(val)
      process.exit(0)
    }
    reached[val] = true
  }
}

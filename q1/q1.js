fs = require("fs")
let input_text = fs.readFileSync("./input.txt", {encoding: 'utf-8'})
let answer = eval(input_text)
console.log(answer)

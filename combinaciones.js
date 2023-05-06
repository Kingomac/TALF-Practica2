
frases = [
  "EN PATH",
  "'(' nombre_lista ')'"
]

resultado = ""

for(let i = 0; i < Math.pow(2,frases.length); i++) {
  let n = Number(i).toString(2).split('').reverse().map((j,index) => {
    if(j == 1) return frases[index]
    else return ""
  });
  console.log(n)
    resultado +=
    `nombre ${n[0] || ""} ${n[1] || ""}\n`
}

console.log(resultado)

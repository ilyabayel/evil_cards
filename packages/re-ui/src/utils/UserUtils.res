let getInitials = userName => {
  let split = Js.String2.split(userName, " ")
  switch Js.Array2.length(split) {
  | 0 => "-_-"
  | 1 => userName -> Js.String2.slice(~from=0, ~to_=2)
  | _ =>
    split
    ->Js.Array2.map(s => Js.String2.toUpperCase(Js.String2.charAt(s, 0)))
    ->Js.Array2.joinWith("")
  }
}

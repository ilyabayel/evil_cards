let getInitials = userName => {
  let split = Js.String2.split(userName, " ")
  switch Array.length(split) {
  | 0 => "-_-"
  | 1 => userName->Js.String2.slice(~from=0, ~to_=2)
  | _ =>
    split
    ->Array.map(s => Js.String2.toUpperCase(Js.String2.charAt(s, 0)))
    ->Array.joinWith("", s => s)
  }
}

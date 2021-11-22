@module external styles: {..} = "./BottomModal.module.css"
let add = ClassName.add
let cond = ClassName.cond

@react.component
let make = (~onClose, ~visible=false, ~closeLabel=`Закрыть`, ~children) => {
  let (hiding, setHiding) = React.useState(_ => false)
  let (hidden, setHidden) = React.useState(_ => true)

  React.useEffect1(() => {
    switch (visible, hidden) {
    | (false, false) => {
        setHiding(_ => true)
        let _id = Js.Global.setTimeout(() => {
          setHiding(_ => false)
          setHidden(_ => true)
        }, 250)
      }
    | (true, _) => setHidden(_ => false)
    | _ => ()
    }
    None
  }, [visible])

  let bgClassName =
    styles["default"]["bottom-modal-background"]
    ->cond(styles["default"]["visible"], visible)
    ->cond(styles["default"]["hiding"], hiding)
    ->cond(styles["default"]["hidden"], hidden)

  let modalClassName =
    styles["default"]["bottom-modal"]
    ->cond(styles["default"]["visible"], visible)
    ->cond(styles["default"]["hiding"], hiding)
    ->cond(styles["default"]["hidden"], hidden)

  <div className="wrapper">
    <div className={bgClassName} onClick={onClose} />
    <div className={modalClassName}>
      <button className={styles["default"]["close-btn"]} onClick={onClose}>
        <span> {React.string(closeLabel)} </span>
      </button>
      <div className={styles["default"]["body"]}> children </div>
    </div>
  </div>
}

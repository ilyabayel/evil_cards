@module external styles: {..} = "./Frame.module.css"

@react.component
let make = (~children) => {
  <div className={styles["wrapper"]}> <div className={styles["frame"]}> children </div> </div>
}

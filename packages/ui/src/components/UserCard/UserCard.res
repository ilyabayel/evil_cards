@module external styles: {..} = "./UserCard.module.css"

@react.component
let make = (~userName="", ~avatar="", ~score=0) => {
  <div className={styles["default"]["user-card"]}>
    <div className={styles["default"]["avatar-box"]}>
      {if Js.String2.length(avatar) > 0 {
        <img src=avatar alt="Avatar" className={styles["default"]["avatar"]} />
      } else {
        <div className={styles["default"]["avatar"]}>
          <p> {UserUtils.getInitials(userName)->React.string} </p>
        </div>
      }}
    </div>
    <div className={styles["default"]["info-box"]}>
      <h5> {React.string(userName)} </h5> <p> {React.string(j`$score`)} </p>
    </div>
  </div>
}

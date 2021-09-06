type ConditionalClassname = [string, boolean]

type ClassName = string | ConditionalClassname | undefined

export function cn(...classNames: ClassName[]): string {
    let result = ""
    for (let className of classNames) {
        if (typeof className === 'string') {
            result += className
            result += " "
        }
        if (className instanceof Array) {
            if (className[1] === true) {
                result += className[0]
                result += " "
            }
        }
    }
    return result.trimEnd()
}
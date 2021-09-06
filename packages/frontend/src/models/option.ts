export class Option {
    constructor(public id: string, public value: string) {
    }
}

export class EmptyOption extends Option {
    constructor() {
        super("", "______")
    }
}

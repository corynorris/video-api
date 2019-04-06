import React, { Component } from "react";

export default class Dropdown extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { options, name } = this.props;

    return (
      <div class="select">
        <select name={name}>
          {options.map(item => (
            <option value={item.id}>{item.label}</option>
          ))}
        </select>
      </div>
    );
  }
}

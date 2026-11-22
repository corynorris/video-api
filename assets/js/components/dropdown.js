import React, { Component } from "react";
import PropTypes from "prop-types";

export default class Dropdown extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { options, name } = this.props;

    return (
      <div className="select">
        <select name={name}>
          {options.map((item) => (
            <option key={item.id} value={item.id}>
              {item.label}
            </option>
          ))}
        </select>
      </div>
    );
  }
}

Dropdown.propTypes = {
  options: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
      label: PropTypes.string.isRequired,
    }),
  ).isRequired,
  name: PropTypes.string.isRequired,
};

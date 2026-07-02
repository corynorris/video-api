import React, { Component } from "react";
import PropTypes from "prop-types";
import Dropdown from "../components/dropdown";

export default class PropertySelect extends Component {
	constructor(props) {
		super(props);
	}

	render() {
		return (
			<div className="field">
				<label className="label">{this.props.label}</label>
				<div className="control">
					<Dropdown
						name="property"
						options={this.props.properties.map((item) => ({
							id: item.id,
							label: item.label,
						}))}
					/>
				</div>
			</div>
		);
	}
}

PropertySelect.propTypes = {
	label: PropTypes.string.isRequired,
	properties: PropTypes.arrayOf(
		PropTypes.shape({
			id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]).isRequired,
			label: PropTypes.string.isRequired,
		}),
	).isRequired,
};

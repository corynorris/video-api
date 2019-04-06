import React, { Component } from "react";
import MultiSelect from "@kenshooui/react-multi-select";
import "@kenshooui/react-multi-select/dist/style.css";

export default class VideoSelect extends Component {
  constructor(props) {
    super(props);
    this.updateSelectedItems = this.updateSelectedItems.bind(this);
    this.state = {
      selectedItems: [],
      selectedIds: []
    };
  }

  updateSelectedItems(selectedItems) {
    this.setState({ selectedItems });
    this.setState({ selectedIds: selectedItems.map(item => item.id) });
  }

  render() {
    const { selectedItems, selectedIds } = this.state;
    const selectedIdString = selectedIds.join(",");

    const { videos } = this.props;
    const items = videos.map(item => ({ id: item.id, label: item.title }));

    return (
      <div className="field">
        <label className="label">{this.props.label}</label>
        <MultiSelect
          items={items}
          selectedItems={selectedItems}
          onChange={this.updateSelectedItems}
        />
        <input
          name="videos"
          className="input"
          type="hidden"
          value={selectedIdString}
        />
      </div>
    );
  }
}

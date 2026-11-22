import React, { Component } from "react";
import { createRoot } from "react-dom/client";
import VideoSelect from "../components/video_select";
import PropertySelect from "../components/property_select";

class PublishPage extends Component {
  constructor(props) {
    super(props);
    this.state = {
      videos: [],
      properties: [],
    };
  }

  componentDidMount() {
    fetch("/videos/json")
      .then((response) => response.json())
      .then((data) => {
        this.setState({
          videos: data.videos,
          properties: data.properties,
        });
      });
  }

  render() {
    const { videos, properties } = this.state;
    return (
      <div>
        <PropertySelect
          label="Property to Publish to"
          properties={properties}
        />
        <VideoSelect label="Videos to Publish" videos={videos} />
        <div className="control">
          <button className="button is-link">Publish</button>
        </div>
      </div>
    );
  }
}

export default function () {
  createRoot(document.getElementById("video-select")).render(<PublishPage />);
}

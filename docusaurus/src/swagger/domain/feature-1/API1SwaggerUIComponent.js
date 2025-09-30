import React from 'react';
import SwaggerUI from 'swagger-ui-react';
import 'swagger-ui-react/swagger-ui.css';
import SwaggerAutoExpandByHash from "../../../components/SwaggerAutoExpandByHash"; 

const API1SwaggerUIComponent = () => {
  return (
    <div style={{ height: '80vh', width: '100%', overflowY: 'scroll' }}>
      <SwaggerUI url="/swagger/feature/feature-1/feature-1.yaml" /> {/* DIDVC APIのYAMLファイルを指定 */}

      <SwaggerAutoExpandByHash />
    </div>
  );
};

export default API1SwaggerUIComponent;

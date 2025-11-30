import React from 'react';
import SwaggerUI from 'swagger-ui-react';
import 'swagger-ui-react/swagger-ui.css';

const SampleBackendSwaggerUIComponent = () => {
  return (
    <div style={{ height: "80vh", width: "100%", overflowY: "scroll" }}>
      <SwaggerUI url="/swagger/microservice/sample-backend-openapi.yaml" />
    </div>
  );
};

export default SampleBackendSwaggerUIComponent;

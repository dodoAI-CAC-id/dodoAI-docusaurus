import React from 'react';
import OriginalLayout from '@theme-original/Layout';
import AuthWrapper from '../../lib/AuthWrapper'; // Import your AuthWrapper

export default function Layout(props) {
  return (
    <AuthWrapper>
      <OriginalLayout {...props} />
    </AuthWrapper>
  );
}
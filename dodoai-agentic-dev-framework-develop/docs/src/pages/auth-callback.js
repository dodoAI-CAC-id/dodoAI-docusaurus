import React, { useEffect, useState } from 'react';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';

export default function GitHubCallbackPage() {
  const [error, setError] = useState(null);
  const { siteConfig } = useDocusaurusContext();
  console.log('Site Config:', siteConfig);

  useEffect(() => {
    const handleGitHubOAuthCallback = async () => {
      const url = new URL(window.location.href);
      const code = url.searchParams.get('code');
      const state = url.searchParams.get('state');
      const savedState = localStorage.getItem('github_oauth_state');

      if (!code || !state || !savedState || state !== savedState) {
        throw new Error('Invalid GitHub OAuth state or missing code.');
      }

      localStorage.removeItem('github_oauth_state');
      const endpoint = siteConfig.customFields.authApiUrl;
      if (!endpoint) {
        throw new Error('REACT_APP_AUTH_API_URL is not defined.');
      }

      const response = await fetch(`${endpoint}/github/oauth/token`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ code, repository: siteConfig.customFields.githubRepoName }),
      });

      if (!response.ok) {
        const body = await response.text();
        throw new Error(`Token exchange failed: ${body}`);
      }

      const data = await response.json();
      const token = data.access_token;

      if (!token) {
        throw new Error('Access token not returned.');
      }

      sessionStorage.setItem('github_token', token);
    };

    handleGitHubOAuthCallback()
      .then(() => window.location.href = '/')
      .catch((err) => {
        console.error('OAuth callback error:', err);
        setError(err.message || 'GitHub login failed.');
      });
  }, []);

  return (
    <div style={{ padding: '2rem' }}>
      {error ? (
        <p style={{ color: 'red' }}>OAuth Error: {error}</p>
      ) : (
        <p>Logging you in via GitHub...</p>
      )}
    </div>
  );
}

import React, { useEffect, useState } from 'react';
import {
  onAuthStateChanged,
  getRedirectResult,
} from 'firebase/auth';
import { initAuth } from './firebaseConfig';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';

async function validateGitHubRepoAccess(token, repos, apiUrl) {
  console.log('Checking GitHub access for repos: ' + JSON.stringify(repos));
  try {
    const response = await fetch(`${apiUrl}/github/validate-access`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ repos }),
    });
    if (!response.ok) throw new Error('API response not OK');
    const result = await response.json();
    return result.hasAccess === true;
  } catch (err) {
    console.error('Access check failed:', err);
    throw err;
  }
}

export default function AuthWrapper({ children }) {
  const { siteConfig } = useDocusaurusContext();
  const { auth, githubConfig } = initAuth(siteConfig.customFields || {});
  const isSSR = typeof window === 'undefined';
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(!isSSR);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (isSSR) return;

    const isAuthDisabled = !auth && !githubConfig?.enabled;
    if (isAuthDisabled) {
      setLoading(false);
      return;
    }

    if (auth) {
      const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
        if (currentUser) {
          setUser(currentUser);
        } else if (window.location.href.indexOf('/login') < 0) {
          window.location.href = '/login';
        }
        setLoading(false);
      });

      return () => unsubscribe();
    }

    if (!auth && githubConfig?.enabled) {
      const token = sessionStorage.getItem('github_token');
      const apiUrl = githubConfig.authApiUrl;
      const repos = githubConfig.repos || [
        { owner: githubConfig.repoOwner, name: githubConfig.repoName },
      ];
      const hasRedirected = sessionStorage.getItem('github_login_redirected');

      if (token) {
        validateGitHubRepoAccess(token, repos, apiUrl).then((hasAccess) => {
          if (hasAccess) {
            setUser({});
            setLoading(false);
          } else {
            setError('GitHub Token does not grant access to required repos');
            setLoading(false);
          }
        }).catch((err) => {
          console.error('GitHub access validation error:', err);
          setError('アクセス権限がありません。');
          setLoading(false);
        });
        return;
      }

      if (!token && !hasRedirected) {
        sessionStorage.setItem('github_login_redirected', 'true');
        redirectToGitHubOAuth();
        return;
      }

      sessionStorage.removeItem('github_login_redirected');
      setError('GitHub Token not found');
      setLoading(false);
      return;
    }
  }, []);

  // Generates a cryptographically secure random state string
  function generateSecureState(length = 32) {
    const array = new Uint8Array(length);
    crypto.getRandomValues(array);
    return Array.from(array, (byte) => byte.toString(36)).join('').slice(0, length);
  }


  const redirectToGitHubOAuth = () => {
    const clientId = githubConfig.clientId || '';
    const redirectUri = encodeURIComponent(window.location.origin + '/auth-callback');
    const state = generateSecureState();
    const scope = encodeURIComponent('read:user repo');

    localStorage.setItem('github_oauth_state', state);

    const githubOAuthUrl = `https://github.com/login/oauth/authorize?client_id=${clientId}&redirect_uri=${redirectUri}&state=${state}&scope=${scope}`;
    window.location.href = githubOAuthUrl;
  };

  if (loading) return <p>Loading...</p>;
  if (error)
    return (
      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          height: '100vh',
        }}
      >
        <p style={{ color: 'red', fontSize: '1.2em' }}>認証エラー: {error}</p>
      </div>
    );

  return <>{children}</>;
}

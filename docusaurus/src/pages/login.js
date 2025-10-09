import React, { useState } from 'react';
import Layout from '@theme/Layout';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import {
  signInWithEmailAndPassword,
  getMultiFactorResolver,
  TotpMultiFactorGenerator, // Import this for TOTP MFA
} from 'firebase/auth';
import { initAuth } from '../lib/firebaseConfig';
import { signInWithGitHub } from '../lib/githubAuth';
import { getGithubAuthConfig } from '../lib/firebaseConfig';

export default function LoginPage() {
  const { siteConfig } = useDocusaurusContext();
  const customFields = siteConfig.customFields || {};
  
  console.log('CustomFields:', customFields);
  console.log('Firebase Project ID:', customFields.firebaseProjectId);
  
  const { auth } = initAuth(customFields);
  const githubAuthConfig = getGithubAuthConfig(customFields);
  
  console.log('Auth initialized:', auth ? 'success' : 'failed');
  
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);

  const handleMfaLogin = async () => {
    setError(null); // Clear any previous errors

    if (!auth) {
      setError('Firebase auth is not configured');
      return;
    }

    try {
      // Step 1: Attempt login with email and password
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      console.log('User signed in:', userCredential);

      alert('Login successful');
      window.location.href = '/'; // Redirect after successful login
    } catch (error) {
      if (error.code === 'auth/multi-factor-auth-required' && error.customData) {

        const enrollmentId = error.customData._serverResponse.mfaInfo[0].mfaEnrollmentId;

        // Step 4: Prompt user for TOTP code
        const totpCode = prompt('Enter the 6-digit code from your authenticator app.');
        if (!totpCode) {
          throw new Error('TOTP code is required.');
        }

        // Step 5: Create assertion and resolve MFA sign-in
        const assertion = TotpMultiFactorGenerator.assertionForSignIn(enrollmentId, totpCode);
        const mfaResolver = getMultiFactorResolver(auth, error);
        const result = await mfaResolver.resolveSignIn(assertion);

        // Success
        console.log('MFA Sign-in successful:', result);

        window.location.href = '/'; // Redirect after successful login

      } else {
        console.error('Error during MFA login:', error.message);
        setError(error.message || 'Login failed. Please try again.');
      }
    }
  };

  const handleGitHubLogin = async () => {
    setError(null);
    setLoading(true);
    
    try {
      await signInWithGitHub(githubAuthConfig.repoOwner, githubAuthConfig.repoName);
      alert('GitHub login successful');
      window.location.href = '/';
    } catch (error) {
      console.error('GitHub login error:', error.message);
      setError(error.message || 'GitHub login failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Layout title="Login">
      <div style={{ padding: '2rem', margin: '10px auto' }}>
        <h1>Login</h1>
        <input
          style={{ marginBottom: '1rem', padding: '5px' }}
          type="email"
          placeholder="Email"
          value={email}
          size={50}
          onChange={(e) => setEmail(e.target.value)}
        />
        <br />
        <input
          style={{ marginBottom: '1rem', padding: '5px' }}
          type="password"
          placeholder="Password"
          value={password}
          size={50}
          onChange={(e) => setPassword(e.target.value)}
        />
        <br />
        <button style={{ padding: '5px', marginBottom: '1rem' }}
          onClick={handleMfaLogin} disabled={loading}>
          dodoAI Account Login
        </button>
        
        {githubAuthConfig.enabled && (
          <>
            <br />
            <button style={{ padding: '5px', marginBottom: '1rem', backgroundColor: '#333', color: 'white' }}
              onClick={handleGitHubLogin} disabled={loading}>
              GitHub Login
            </button>
          </>
        )}
        
        {error && <p style={{ color: 'red' }}>{error}</p>}
        {loading && <p>Loading...</p>}
        <br />※If you do not have a dodoAI account, please sign up at <a href="https://dodoai.cacidentity.com/">https://dodoai.cacidentity.com/</a>
      </div>
    </Layout>
  );
}

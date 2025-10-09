import { GithubAuthProvider, signInWithPopup, signInWithRedirect, getRedirectResult } from 'firebase/auth';
import { initAuth } from './firebaseConfig';

export const githubProvider = new GithubAuthProvider();
githubProvider.addScope('repo');

export const validateGitHubRepoAccess = async (accessToken, repoOwner, repoName) => {
  try {
    const response = await fetch(`https://api.github.com/repos/${repoOwner}/${repoName}`, {
      headers: {
        'Authorization': `token ${accessToken}`,
        'Accept': 'application/vnd.github.v3+json'
      }
    });
    
    if (response.status === 200) {
      return { hasAccess: true, error: null };
    } else if (response.status === 404) {
      return { hasAccess: false, error: 'Repository not found or no access permissions' };
    } else {
      return { hasAccess: false, error: `GitHub API error: ${response.status}` };
    }
  } catch (error) {
    return { hasAccess: false, error: `Network error: ${error.message}` };
  }
};

export const signInWithGitHub = async (repoOwner, repoName) => {
  try {
    const { auth } = initAuth(typeof window !== 'undefined' && window.docusaurus?.siteConfig?.customFields || {});
    if (!auth) {
      throw new Error('Firebase auth is not configured');
    }
    
    const result = await signInWithPopup(auth, githubProvider);
    const credential = GithubAuthProvider.credentialFromResult(result);
    const token = credential.accessToken;
    
    const validation = await validateGitHubRepoAccess(token, repoOwner, repoName);
    if (!validation.hasAccess) {
      await auth.signOut();
      throw new Error(validation.error);
    }
    
    return { user: result.user, token };
  } catch (error) {
    throw error;
  }
};

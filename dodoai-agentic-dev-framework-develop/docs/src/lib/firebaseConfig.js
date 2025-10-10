import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';

export const getGithubAuthConfig = (customFields = {}) => ({
  enabled: customFields.githubAuthEnabled || false,
  repoOwner: customFields.githubRepoOwner || '',
  repoName: customFields.githubRepoName || '',
  clientId: customFields.githubClientId || '',
  authApiUrl: customFields.authApiUrl || '',
});

export const getFirebaseConfig = (customFields = {}) => ({
  apiKey: customFields.firebaseApiKey || "",
  authDomain: customFields.firebaseAuthDomain || "",
  projectId: customFields.firebaseProjectId || "",
  storageBucket: customFields.firebaseStorageBucket || "",
  messagingSenderId: customFields.firebaseMessagingSenderId || "",
  appId: customFields.firebaseAppId || "",
  measurementId: customFields.firebaseMeasurementId || ""
});

export const initAuth = (customFields = {}) => {
  const githubConfig = getGithubAuthConfig(customFields);
  const firebaseConfig = getFirebaseConfig(customFields);

  if (firebaseConfig.projectId) {
    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);
    return { auth, githubConfig };
  }

  // Firebase未使用の場合
  return {
    auth: null, // nullにして正しく判定させる
    githubConfig
  };
};

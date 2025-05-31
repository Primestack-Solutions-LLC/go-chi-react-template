import { Routes, Route, Navigate } from 'react-router-dom'
import Layout from '@/components/Layout'
import Home from '@/pages/Home'
import Login from '@/pages/Login'
import Dashboard from '@/pages/Dashboard'
import { useAuthStore } from '@/stores/authStore'

function App() {
  const { isAuthenticated } = useAuthStore()

  return (
    <Layout>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/login" element={<Login />} />
        <Route
          path="/dashboard"
          element={
            isAuthenticated ? <Dashboard /> : <Navigate to="/login" replace />
          }
        />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Layout>
  )
}

export default App


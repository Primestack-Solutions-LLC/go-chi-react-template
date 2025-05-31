export interface User {
  id: number
  name: string
  email: string
  createdAt: string
  active: boolean
}

export interface LoginRequest {
  email: string
  password: string
}

export interface RegisterRequest {
  name: string
  email: string
  password: string
  confirmPassword: string
}

export interface AuthResponse {
  token: string
  user: User
  expiresAt: string
}


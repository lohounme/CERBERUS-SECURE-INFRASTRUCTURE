const express = require('express');
const helmet = require('helmet');

const app = express();
const PORT = process.env.PORT || 3000;

// 🛡️ SÉCURITÉ 1 : En-têtes HTTP de sécurité via Helmet
// Fix nikto DAST Finding: X-Content-Type-Options explicitly enforced
app.use(helmet({
  contentSecurityPolicy: false, // API REST, pas de HTML
  noSniff: true,                // X-Content-Type-Options: nosniff (Fix nikto finding)
  frameguard: { action: 'sameorigin' }, // X-Frame-Options: SAMEORIGIN
  xssFilter: true,              // X-XSS-Protection
  hsts: false,                  // Pas de HTTPS en local kind cluster
}));

// 🛡️ SÉCURITÉ 2 : Limiter la taille des payloads JSON (protection DoS)
app.use(express.json({ limit: '10kb' }));

// 🛡️ SÉCURITÉ 3 : Masquer l'empreinte serveur Express
app.disable('x-powered-by');

// 🟢 SONDE KUBERNETES : Endpoint Health Check (Liveness / Readiness)
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'UP',
    service: 'cerberus-api',
    uptime: process.uptime(),
    timestamp: new Date().toISOString()
  });
});

// 📊 ENDPOINT METRIQUES & STATUT API
app.get('/api/v1/status', (req, res) => {
  res.status(200).json({
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0',
    security: {
      nonRootEnforced: true,
      helmetActive: true
    }
  });
});

// 🔒 RESSOURCE METIER APPLICATIVE
app.get('/api/v1/data', (req, res) => {
  res.status(200).json({
    success: true,
    data: [
      { id: 1, policy: 'disallow-root-user', status: 'Enforced' },
      { id: 2, policy: 'network-isolation', status: 'Active' }
    ]
  });
});

// 404 Route non trouvée
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint non trouve' });
});

// Démarrage du serveur
const server = app.listen(PORT, () => {
  console.log(`[CERBERUS-API] Serveur sécurisé démarré sur le port ${PORT}`);
});

// 🛡️ ZERO-DOWNTIME KUBERNETES : Interception propre des signaux d'arrêt
const shutdown = (signal) => {
  console.log(`[CERBERUS-API] Signal ${signal} reçu. Fermeture propre...`);
  server.close(() => {
    console.log('[CERBERUS-API] Connexions fermées. Arrêt du processus.');
    process.exit(0);
  });
};

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));

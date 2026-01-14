import cors from "cors";
import express from "express";
import { rateLimit } from "express-rate-limit";
import helmet from "helmet";
import morgan from "morgan";

const app = express();

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  limit: 100, // Limit each IP to 100 requests per `window` (here, per 15 minutes).
  standardHeaders: "draft-8", // draft-6: `RateLimit-*` headers; draft-7 & draft-8: combined `RateLimit` header
  legacyHeaders: false, // Disable the `X-RateLimit-*` headers.
  ipv6Subnet: 56, // Set to 60 or 64 to be less aggressive, or 52 or 48 to be more aggressive
});

app.use(cors());
app.use(express.json());
app.use(helmet());
app.use(limiter);
app.use(morgan("combined"));

app.get("/api/health", (_, res) => {
  res.json({ ok: true });
});

app.listen(4000, () => {
  console.log("API running on http://localhost:4000");
});

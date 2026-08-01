import cors from "cors";
import dotenv from "dotenv";
import express, {type Request, type Response} from "express";

dotenv.config();

const app = express();

const PORT = Number(process.env.PORT) || 5001;

app.use(cors());
app.use(express.json());

app.get('/api/health', (_request: Request, response: Response) => {
    response.status(200).json({
        success:true,
        message: "API is healthy",
        timestamp: new Date().toISOString()
    });
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
})
export interface ApiResponse<T>{
    success: boolean;
    message: string;
    data?: T; // Optional property to hold the response data of type T -> generic type
}
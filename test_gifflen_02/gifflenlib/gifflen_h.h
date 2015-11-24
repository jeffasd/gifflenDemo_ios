
//author jeffasd

//int giffle_Giffle_Init( const char *,int w, int h, int numColors, int quality, int frameDelay);
//void  giffle_Giffle_Close();
//int  giffle_Giffle_AddFrame(int * intPoint);


extern "C"
{
    int giffle_Giffle_Init(const char * gifName, int w, int h, int numColors, int quality, int frameDelay);
    void  giffle_Giffle_Close();
    int  giffle_Giffle_AddFrame(const int * intPoint);
};
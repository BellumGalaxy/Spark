import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UserModule } from './user/user.module';
import { AuthModule } from './auth/auth.module';
import { AthleteModule } from './athlete/athlete.module';
import { ReceiptModule } from './receipt/receipt.module';
import { SponsorshipModule } from './sponsorship/sponsorship.module';

@Module({
  imports: [UserModule, AuthModule, AthleteModule, ReceiptModule, SponsorshipModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

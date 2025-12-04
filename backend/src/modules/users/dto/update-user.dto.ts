import { Transform } from 'class-transformer';
import { IsNotEmpty, IsString, MaxLength, MinLength } from 'class-validator';

export class UpdateUserDto {
  @IsString()
  @IsNotEmpty()
  @MinLength(6)
  @MaxLength(20)
  name?: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  @MaxLength(25)
  @Transform(({ value }) => value.trim())
  password?: string;
}

import { Transform } from 'class-transformer';
import { IsNotEmpty, IsOptional, MaxLength, MinLength } from 'class-validator';

export class UpdateDto {
  @IsOptional()
  @IsNotEmpty()
  @MinLength(6)
  @MaxLength(20)
  name: string;

  @IsOptional()
  @Transform(({ value }) => value.trim())
  @MinLength(8)
  @MaxLength(25)
  @IsNotEmpty()
  password?: string;
}
